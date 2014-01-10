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

def support_file_path(name)
  File.expand_path(File.dirname(__FILE__) + name)
end

def stub_successful_run
  with_successful_stdout do |out|
    process = double(Process::Status, :success? => true)
    thread = double('wait_thr', pid: 1, value: process)
    err = StringIO.new('')
    Open3.stub(:popen3).and_yield(StringIO.new(''), out, err, thread)
    if block_given?
      yield out, err, thread.value
    end
  end
end

def stub_failed_run
  with_failed_stderr do |err|
    stub_failed_run_err(err) do | out, err, thread|
      if block_given?
        yield out, err, thread
      end
    end
  end
end

def stub_failed_run_err(err_io)
  out = StringIO.new('')
  process = double(Process::Status, :success? => false)
  thread = double('wait_thr', pid: 1, value: process)
  Open3.stub(:popen3).and_yield(StringIO.new(''), out, err_io, thread)
  if block_given?
    yield out, err_io, thread.value
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
