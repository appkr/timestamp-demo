<?php

namespace App;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * @property integer $id
 * @property string $body
 * @property Carbon $created_at
 * @property Carbon $updated_at
 */
class Post extends Model
{
    public function a()
    {
        date_default_timezone_get();
    }
}
