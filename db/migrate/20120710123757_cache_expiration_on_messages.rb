#encoding: utf-8

class CacheExpirationOnMessages < ActiveRecord::Migration
  # jest nauczka na przyszłość, te trzy poprzednie migracje powinny być w jednym pliku, trzeba uważać jak się zmienia
  # coś w modelach, bo może być kiszka i godzina szukania błędów!

  def up
    Message.first.expire_all_cache unless Message.first.nil?
  end

  def down
    Message.first.expire_all_cache unless Message.first.nil?
  end
end
