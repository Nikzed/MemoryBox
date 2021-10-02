cd C:/important/StudioProjects/MemoryBox
git add .
timestamp() {
  date +"at %H:%M:%S on %d/%m/%Y"
}
git commit -am "Regular auto-commit $(timestamp)"
git push
