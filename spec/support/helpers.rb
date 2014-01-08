def test_path
  support_file_path("/tests")
end

def with_fake_stderr
  err = File.open(File.expand_path(File.dirname(__FILE__) + "/stderr_sample"))
  yield err
  err.close
end

def with_fake_stdout_and_err
  err = File.open(support_file_path("/stderr_sample"))
  out = File.open(support_file_path("/stderr_sample"))
  yield out, err
  err.close
  out.close
end

def support_file_path(name)
  File.expand_path(File.dirname(__FILE__) + name)
end
