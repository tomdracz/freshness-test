# Freshness check

Tested on OSX, could use some tests on different OSes to ensure same behaviour

## Running

```
  bundle install
  ruby freshness_test.rb
```

## Tests

Before each test, we setup few files and directories and record latest modifed mtime

Each test, does a certain file or directory manipulation and tries to assert that the latest mtime is now newer than one recorded in the setup

## Results

| Test               | Result  |
|--------------------|---------|
| Adding file        | &check; |
| Modifying file     | &check; |
| Renaming file      | &check; |
| Removing file      | &check; |
| Adding directory   | &check; |
| Renaming directory | &cross; |
| Removing directory | &cross; |

## Notes

All tests pass if `testdir` (i.e. parent directory is included in mtime checking)

If only files are considered (i.e. `.reject { |f| File.directory?(f) }` added), then only adding file and modifying file checks pass.