const core = require("@actions/core");
const github = require("@actions/github");

try {
  const tagsString = core.getInput("tags");
  const major = core.getInput("major");
  console.log(
    `Filtering input tags '${tagsString}' for major version ${major}`
  );

  let filteredTags = [];
  let matrix = { include: [] };
  tagsString.split(",").forEach((tag) => {
    if (tag.match(`^${major}(?:$|[\\.\\-])`)) {
      filteredTags.push(tag);
      let metaTag =
        (tag == major ? "type=raw,value=latest\n" : "") +
        `type=raw,value=${tag}`;
      matrix.include.push({
        tag: tag,
        meta_tag: metaTag,
      });
    }
  });

  if (!filteredTags) {
    matrix = {};
  }

  core.setOutput("count", filteredTags.length);
  core.setOutput("tags", JSON.stringify(filteredTags));
  core.setOutput("matrix", JSON.stringify(matrix));
} catch (error) {
  core.setFailed(error.message);
}
