<?php

namespace App\Http\Controllers;

use App\Http\Requests\PostRequest;
use App\Http\Resources\PostResource;
use App\Post;
use Illuminate\Http\JsonResponse;

class PostController extends Controller
{
    public function __invoke(PostRequest $request): JsonResponse
    {
        $model = $this->toModel($request);
        $model->save();
        $resource = $this->toResource($model->fresh());

        return new JsonResponse($resource);
    }

    private function toModel(PostRequest $request): Post
    {
        $model = new Post();
        $model->body = $request->getBody();

        return $model;
    }

    private function toResource(Post $model): PostResource
    {
        $resource = new PostResource();
        $resource->setId($model->id);
        $resource->setBody($model->body);
        $resource->setCreatedAt($model->created_at);
        $resource->setUpdatedAt($model->updated_at);

        return $resource;
    }
}
