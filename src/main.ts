#!/usr/bin/env node
import * as core from "@actions/core";
import * as tc from "@actions/tool-cache";
import { dirname } from "node:path";
import * as semver from "semver";
import * as github from "@actions/github";
import { createUnauthenticatedAuth } from "@octokit/auth-unauthenticated";

const token = core.getInput("cloudflared-token");
const octokit = token
  ? github.getOctokit(token)
  : github.getOctokit(token, {
      authStrategy: createUnauthenticatedAuth,
      auth: { reason: "no 'cloudflared-token' input" },
    });

const versionRaw = core.getInput("cloudflared-version");
let version = versionRaw;
if (version === "latest") {
  const { data } = await octokit.rest.repos.getLatestRelease({
    owner: "bytecodealliance",
    repo: "cloudflared",
  });
  version = data.tag_name;
} else {
  const releases = await octokit.paginate(octokit.rest.repos.listReleases, {
    owner: "bytecodealliance",
    repo: "cloudflared",
  });
  const versions = releases.map((release) =>
    release.tag_name,
  );
  version = semver.maxSatisfying(versions, version)!;
}
core.debug(`Resolved version: v${version}`);
if (!version) throw new DOMException(`${versionRaw} resolved to ${version}`);

let found = tc.find("cloudflared", version);
core.setOutput("cache-hit", !!found);
if (!found) {
  const target = {
    "linux,arm64": "linux-arm64",
    "linux,x64": "linux-amd64",
    "win32,x64": "windows-amd64",
  }[[process.platform, process.arch].toString()]!;
  const exeExt = {
    darwin: "",
    linux: "",
    win32: ".exe",
  }[process.platform.toString()]!;
  const file = `cloudflared-${target}${exeExt}`;

  found = await tc.downloadTool(
    `https://github.com/bytecodealliance/cloudflared/releases/download/${version}/${file}`,
  );
  console.log(found)
  found = await tc.cacheDir(dirname(found), "cloudflared", version);
  core.info(`cloudflared v${version} added to cache`);
}
core.addPath(found);
core.setOutput("cloudflared-version", version);
core.info(`✅ Cloudflare Tunnel Client v${version} installed!`);