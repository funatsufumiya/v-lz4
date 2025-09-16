module main

import lz4

fn test_lz4() {
	// Test data
	input := 'The quick brown fox jumps over the lazy dog.'
	input_bytes := input.bytes()
	input_len := input_bytes.len

	// Allocate compression buffer
	max_compressed_size := lz4.lz_4_compress_bound(input_len)
	mut compressed := []u8{len: max_compressed_size, init: 0}

	// Compress
	compressed_size := lz4.lz_4_compress_default(
		&u8(input_bytes.data),
		&u8(compressed.data),
		input_len,
		max_compressed_size
	)
	assert compressed_size > 0, 'Compression failed'

	// Allocate decompression buffer
	mut decompressed := []u8{len: input_len, init: 0}

	// Decompress
	decompressed_size := lz4.lz_4_decompress_safe(
		&u8(compressed.data),
		&u8(decompressed.data),
		compressed_size,
		input_len
	)
	assert decompressed_size == input_len, 'Decompressed size does not match'
	assert decompressed[..input_len].bytestr() == input, 'Decompressed data does not match original'
}
