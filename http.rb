def test
	puts yield
end

test do
	'some text'
end