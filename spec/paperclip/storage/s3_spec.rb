# frozen_string_literal: true

require 'spec_helper'

describe Paperclip::Storage::S3 do
  context '#expiring_url_with_name' do
    def build_attachment(extra_options = {})
      options = {
        storage: :s3,
        bucket: 'testing',
        s3_region: 'eu-west-1',
        s3_credentials: { access_key_id: 'AKIAEXAMPLE', secret_access_key: 'example' },
        path: ':class/:style.:extension'
      }
      rebuild_model options.merge(extra_options)
      dummy = Dummy.new
      dummy.avatar = File.new(fixture_file('5k.png'), 'rb')
      dummy.avatar
    end

    it 'returns an https url when no protocol is configured' do
      url = build_attachment.expiring_url_with_name(60, 'file.png')
      expect(url).to start_with 'https://'
      expect(url).to include 'response-content-disposition'
    end

    it 'returns an https url when https protocol is configured' do
      expect(build_attachment(s3_protocol: 'https').expiring_url_with_name(60)).to start_with 'https://'
    end

    it 'returns an http url only when http protocol is configured explicitly' do
      expect(build_attachment(s3_protocol: 'http').expiring_url_with_name(60)).to start_with 'http://'
    end
  end
end
