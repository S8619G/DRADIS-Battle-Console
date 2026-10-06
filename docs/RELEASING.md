# Releasing a new version

Finished games (the Windows `.exe` and the Mac `.dmg`) are not stored in the repository itself. They are attached to a GitHub Release, where players can download them.

## 1. Update the source

1. Replace the project files in the repository with the new version's files (scripts, scenes, assets, `project.godot`, `export_presets.cfg`).
2. Add the new version's changes to the top of `CHANGELOG.md`.
3. Update `docs/USER_GUIDE.md` if the new version includes a new guide.
4. Commit with a message such as `Version 1.08`.

## 2. Export the games

Follow the **Export** section of `docs/USER_GUIDE.md`. Godot 4.7 export templates must be installed once (**Editor > Manage Export Templates**). Check that **Build > Development Build** on the DradisConsole node is off before exporting.

Every release should include all three so it covers Windows x64, Windows arm64, and Macs with Apple M-series chips or Intel processors (the Mac preset builds one Universal app for both). Recommended file names:

- `DRADIS_Battle_Console_1.08_Windows_x64.exe`
- `DRADIS_Battle_Console_1.08_Windows_arm64.exe`
- `DRADIS_Battle_Console_1.08_Mac.dmg`

## 3. Publish the release

1. On the repository page, click **Releases**, then **Draft a new release**.
2. Under **Choose a tag**, type `v1.08` and choose **Create new tag**.
3. Title: `DRADIS Battle Console 1.08`.
4. Paste the 1.08 section of `CHANGELOG.md` into the description, followed by the release notice below.
5. Drag the exported `.exe` and `.dmg` files into the attachments box.
6. Click **Publish release**.

GitHub adds the source code as ZIP and TAR downloads to every release automatically.

## Notes for players (worth including in each release description)

- **Windows:** the game is not code-signed, so Windows may show "Windows protected your PC". Click **More info**, then **Run anyway**.
- **Mac:** the app is not notarized. Open the DMG and drag the app to Applications. The first time, macOS may say it cannot check the app. Close that message, open **System Settings > Privacy & Security**, scroll down and click **Open Anyway** next to DRADIS Battle Console.

## Supported computers (paste near the top of each release description)

> Runs on Windows PCs with Intel or AMD processors (x64), Windows PCs with ARM processors (arm64), and Macs with Apple M-series chips or Intel processors (one Universal Mac app).

## Release notice (paste at the end of each release description)

> Unofficial, free, non-commercial fan project. Not affiliated with, authorized or endorsed by Universal City Studios LLC, NBCUniversal, Syfy or any owner of the Battlestar Galactica franchise. All names belong to their respective owners. No footage, images or audio from the series are included. Provided "as is" without warranty; use at your own risk. Contains flashing lights and full-screen flashes; see NOTICE.md for the photosensitivity warning.
