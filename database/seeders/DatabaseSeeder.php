<?php

namespace Database\Seeders;

use App\Models\Booking;
use App\Models\Classroom;
use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create Admin User if not exists
        if (! User::where('email', 'admin@example.com')->exists()) {
            User::factory()->create([
                'name' => 'Admin User',
                'email' => 'admin@example.com',
                'password' => bcrypt('password'),
            ]);
        }

        // Create Classrooms with Bookings
        Classroom::factory(10)
            ->has(Booking::factory()->count(5))
            ->create();
    }
}
