defmodule HolidayTest do
  use ExUnit.Case
  doctest Holiday


  test "init db" do
    assert Holiday.init_db() != []
  end

  test "show_all_events" do
    assert Holiday.show_all_events(Holiday.init_db()) != []
  end

  test "2022-09-01 is holiday?" do
    assert Holiday.is_holiday(Holiday.init_db(), ~D[2022-09-01]) == true
  end

  test "2022-03-24 is holiday?" do
    assert Holiday.is_holiday(Holiday.init_db(), ~D[2022-03-24]) == false
  end

  test "time_until_holiday day?" do
    assert Holiday.time_until_holiday(Holiday.init_db(), :day, ~U[2016-05-24 13:26:08Z]) ==
             7.440185185185185
  end

  test "time_until_holiday hour?" do
    assert Holiday.time_until_holiday(Holiday.init_db(), :hour, ~U[2016-05-24 13:26:08Z]) ==
             178.56444444444443
  end

  test "time_until_holiday minute?" do
    assert Holiday.time_until_holiday(Holiday.init_db(), :minute, ~U[2016-05-24 13:26:08Z]) ==
             10713.866666666667
  end

  test "time_until_holiday second?" do
    assert Holiday.time_until_holiday(Holiday.init_db(), :second, ~U[2016-05-24 13:26:08Z]) ==
             642_832
  end
end
