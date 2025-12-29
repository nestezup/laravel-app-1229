<?php

namespace Database\Factories;

use App\Models\Classroom;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Booking>
 */
class BookingFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $start = $this->faker->dateTimeBetween('this week', '+1 month');
        $end = (clone $start)->modify('+' . $this->faker->numberBetween(1, 4) . ' hours');

        return [
            'classroom_id' => Classroom::factory(),
            'reserver_name' => $this->faker->name(),
            'start_time' => $start,
            'end_time' => $end,
        ];
    }
}
