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
    if (tag.match(`^${major}(?:$|\\.)`)) {
      filteredTags.push(tag);
      matrix.include.push({
        tag: tag,
      });
    }
  });
  core.setOutput("tags", JSON.stringify(filteredTags));
  core.setOutput("matrix", JSON.stringify(matrix));
} catch (error) {
  core.setFailed(error.message);
}
