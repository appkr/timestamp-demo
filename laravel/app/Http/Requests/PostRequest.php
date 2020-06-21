<?php

namespace App\Http\Requests;

class PostRequest extends BaseRequest
{
    public function rules()
    {
        return [
            'body' => 'required',
        ];
    }

    public function getBody()
    {
        return $this->input('body');
    }
}
