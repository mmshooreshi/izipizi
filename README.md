# 📂 dir-bookmarks

  ____________________________________________      __________________________________________
 /                                           /|    /                                         /|
/___________________________________________/ |   /_________________________________________/ |
|                                          |  |   |                                        |  |
|                Bookmark[d]s              |  |   |                 Notes                  |  |
|==========================================|  |   |========================================|  |
| Add Bookmark[d]                          |  |   | Add Note to Bookmark[d]                |  |
| Command: bm <name>                       |  |   | Command: bn <name> <note>              |  |
| Example: bm myproj                       |  |   | Example: bn myproj "My note"           |  |
|------------------------------------------|  |   |----------------------------------------|  |
| Go to Bookmark[d]                        |  |   | List Notes                             |  |
| Command: g <name>                        |  |   | Command: ln                            |  |
| Example: g myproj                        |  |   | Example: ln                            |  |
|------------------------------------------|  |   |----------------------------------------| / 
| List Bookmarks                           |  |   |________________________________________|/  
| Command: bl                              |  |
| Example: bl                              | /
|__________________________________________|/


## 🚀 Installation

Run the following command to install the script:

```sh
curl -sSL https://raw.githubusercontent.com/mmshooreshi/izipizi/main/install.sh | bash
```

## 📖 Usage

- Bookmark[d] the current directory with a memorable alias:
  ```sh
  bm proj
  ```

- Navigate to a bookmarke:D directory:
  ```sh
  g proj
  ```

- List all bookmark[d]s with their paths and notes:
  ```sh
  bl
  ```

- Add a note to a bookmark[d]:
  ```sh
  bn proj "Main project directory"
  ```

- List all notes:
  ```sh
  ln
  ```

## 📂 Example Scenarios

1. Bookmark[d] the current project directory:
    ```sh
    bm proj
    ```

2. Add a note to this bookmark[d]:
    ```sh
    bn proj "Main project directory"
    ```

3. Bookmark[d] the downloads directory:
    ```sh
    bm dl
    ```

4. Add a note to the downloads bookmark[d]:
    ```sh
    bn dl "Downloads folder"
    ```

5. List all bookmark[d]s:
    ```sh
    bl
    ```
    Output:
    ```
    proj: /path/to/project
      Note: proj: Main project directory
    dl: /path/to/downloads
      Note: dl: Downloads folder
    ```

6. Navigate to the project directory:
    ```sh
    g proj
    ```

7. List all notes:
    ```sh
    ln
    ```
    Output:
    ```
    proj: Main project directory
    dl: Downloads folder
    ```

## 🛠 Troubleshooting

- If you encounter issues, ensure that your shell configuration file (`.bashrc` or `.zshrc`) has been updated to source the `bookmarkd.sh` script.
- Restart your terminal or run `source ~/.bashrc` or `source ~/.zshrc` to apply changes.

---

Happy bookmark[d]ing! 📁✨
