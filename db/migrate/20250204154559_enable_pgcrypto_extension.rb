class EnablePgcryptoExtension < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    # enable_extension 'pgjwt' unless extension_enabled?('pgjwt')
  end
end
