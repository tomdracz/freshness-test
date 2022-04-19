require "minitest/autorun"
require "fileutils"

class FreshnessTest < Minitest::Test
  def create_test_dirs_and_files
    FileUtils.mkdir_p('testdir')
    FileUtils.mkdir_p('testdir/javascript')
    FileUtils.mkdir_p('testdir/css')
    File.open('testdir/javascript/pack.js', 'a+') do |f|
      f.write('something js')
    end
    File.open('testdir/javascript/pack.css', 'a+') do |f|
      f.write('something css')
    end
  end

  def get_latest_modified
    latest = Dir.glob('testdir/**/*').reject { |f| File.directory?(f) }.max_by { |f| File.mtime(f) }
    File.mtime(latest).to_i
  end

  def setup
    create_test_dirs_and_files
    @setup_last_modified = get_latest_modified
    # Sleep to advance time
    sleep 2
  end

  def teardown
    FileUtils.remove_dir('testdir')
  end

  def test_adding_file
    File.open('testdir/javascript/anotherpack.js', 'a+') do |f|
      f.write('something js')
    end

    assert get_latest_modified > @setup_last_modified
  end

  def test_modifying_file
    File.open('testdir/javascript/pack.js', 'a+') do |f|
      f.write('something else js')
    end

    assert get_latest_modified > @setup_last_modified
  end

  def test_renaming_file
    FileUtils.mv('testdir/javascript/pack.js', 'testdir/javascript/renamedpack.js')

    assert get_latest_modified > @setup_last_modified
  end

  def test_removing_file
    FileUtils.rm('testdir/javascript/pack.js')

    assert get_latest_modified > @setup_last_modified
  end

  def test_adding_directory
    FileUtils.mkdir_p('testdir/static')

    assert get_latest_modified > @setup_last_modified
  end

  def test_renaming_directory
    FileUtils.mv('testdir/javascript', 'testdir/renamedjavascript')
    
    assert get_latest_modified > @setup_last_modified
  end

  def test_removing_directory
    FileUtils.remove_dir('testdir/javascript')

    assert get_latest_modified > @setup_last_modified
  end
end

# Adding file
# Modifying file
# Renaming file
# Removing file
# Adding directory
# Removing directory
# Renaming directory