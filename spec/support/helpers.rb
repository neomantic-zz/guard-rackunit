def test_path
  support_file_path("/tests")
end

def with_failed_stderr
  File.open(support_file_path("/samples/failed_tests")) do |io|
    yield io
  end
end

def with_successful_stdout
  File.open(support_file_path("/samples/success")) do |io|
    yield io
  end
end

def with_successful_stdout_and_stderr
  with_successful_stdout do |out_io|
    yield out_io, StringIO.new('')
  end
end

def with_failure_stdout_and_stderr
  with_failed_stderr do |err_io|
    yield StringIO.new(''), err_io
  end
end

def support_file_path(name)
  File.expand_path(File.dirname(__FILE__) + name)
end

def stub_successful_run
  status = double(Process::Status, :success? => false)
  process = double('wait_thr', pid: 1, value: status)
  with_successful_stdout_and_stderr do |out, err|
    Open3.stub(:popen3).and_yield(StringIO.new(''), out, err, process)
  end
end

def capture_stdout
  # borrowed from
  # https://github.com/cldwalker/hirb/blob/master/test/test_helper.rb
  # MIT license
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end
