.PHONY: build

build:
	~/Downloads/Godot_v4.2-stable_linux.x86_64 --headless --export-release Web ../build/web/trainer ./src/project.godot
