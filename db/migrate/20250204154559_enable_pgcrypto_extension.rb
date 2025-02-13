class EnablePgcryptoExtension < ActiveRecord::Migration[8.0]
  def change
    unless Rails.env.test?
      enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    end
    # enable_extension 'pgjwt' unless extension_enabled?('pgjwt')
  end
end
