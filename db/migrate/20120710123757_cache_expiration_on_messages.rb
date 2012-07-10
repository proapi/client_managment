#encoding: utf-8

class CacheExpirationOnMessages < ActiveRecord::Migration
  # jest nauczka na przyszłość, te trzy poprzednie migracje powinny być w jednym pliku, trzeba uważać jak się zmienia
  # coś w modelach, bo może być kiszka i godzina szukania błędów!

  def up
    Message.expire_all_cache
  end

  def down
    Message.expire_all_cache
  end
end
