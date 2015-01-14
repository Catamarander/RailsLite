require 'uri'
require 'byebug'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = {}

      if req.query_string
        @params.merge!(parse_www_encoded_form(req.query_string))
      end

      if req.body
        @params.merge!(parse_www_encoded_form(req.body))
      end

      if route_params
        @params.merge!(route_params)
      end
    end

    def [](key)
      @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }

    def parse_www_encoded_form(www_encoded_form)
      unencoded_hash = Hash.new { |h, k| h[k] = {} }
      if www_encoded_form.include?('&')
        string_pieces = www_encoded_form.split('&')
        to_merge = []
        string_pieces.each do |string|
          to_merge << get_single_nested_hash(string)
        end
        first, second = to_merge
        if first.keys[0] == second.keys[0]
          deep_hash_merge(first, second)
        else
          join_hashes_with_different_keys(first, second)
        end
      else
        get_single_nested_hash(www_encoded_form)
      end
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      first_end = key.index("[")
      first = [key[0...first_end]]
      rest_of_pieces = key[first_end+1...-1].split("][")
      first.concat(rest_of_pieces)
    end

    def get_single_nested_hash(string)
      keys, value = string.split("=")
      temp_hash = {}
      if keys.include? "["
        keys = parse_key(keys)

        keys.reverse.each do |key|
          value = {key => value}
          temp_hash = value
        end
      else
        temp_hash[keys] = value
      end
      temp_hash
    end

    def deep_hash_merge(hash1, hash2)
      if ((hash1.keys[0] == hash2.keys[0]) && (hash1.values[0].keys[0] != hash2.values[0].keys[0]))
        return { hash1.keys[0] => join_hashes_with_different_keys(hash1.values[0], hash2.values[0]) }
      end
      {hash1.keys[0] => deep_hash_merge(hash1.values[0], hash2.values[0])}
    end

    def join_hashes_with_different_keys(hash1, hash2)
      new_hash = {}
      hash1.each do |key, value|
        new_hash[key] = value
      end
      hash2.each do |key, value|
        new_hash[key] = value
      end

      new_hash
    end
  end
end
