black oarepo_model_builder_workflows build-tests --target-version py310
autoflake --in-place --remove-all-unused-imports --recursive oarepo_model_builder_workflows build-tests
isort oarepo_model_builder_workflows build-tests  --profile black
