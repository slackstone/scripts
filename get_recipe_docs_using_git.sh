#!/bin/bash
echo "Pull a local copy of the recipe documentation."
git clone https://git.drupalcode.org/project/distributions_recipes.git
cd distributions_recipes
git fetch origin
git checkout -b 1.0.x origin/1.0.x
git branch
