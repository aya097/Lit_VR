#pragma once

static float r3 = 1.7320508;
static float r3i = 0.5773503;

static float2x2 obli_to_rect = float2x2(2, 0, -1, r3i);
static float2x2 rect_to_obli = float2x2(.5, 0, r3 * .5, r3);

void Hex_float(float2 uv, float scale, out float2 hex_uv)
{
    uv = mul(obli_to_rect, uv * scale);
   float2 index = floor(uv);    // 整数部分
   float2 pos = frac(uv);       // 小数部分
   
   // 上半分かどうか
   float upper = 1 - step(pos.x + pos.y * 3., 2.);
   // 領域は点対称なので上半分なら折り返す
   pos = lerp(pos, 1. - pos, upper);
   // 右側の六角形に含まれるかどうか、折り返しも考慮して判定
   float right = 1. - abs(upper - step(pos.x * 2. + pos.y * 3., 1.));
   
   // 六角形の重心座標を計算
   index.x += right;
   index.y += upper;
   
   hex_uv = mul(rect_to_obli, index) / scale;
}