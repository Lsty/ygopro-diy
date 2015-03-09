--不动的大图书馆 帕秋莉·诺蕾姬
function c81100007.initial_effect(c)
	c:SetUniqueOnField(1,0,81100007)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c81100007.hspcon)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	e2:SetCondition(c81100007.condition1)
	c:RegisterEffect(e2)
	--change base attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c81100007.condition2)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetValue(3000)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c81100007.condition3)
	e4:SetTarget(c81100007.drtg)
	e4:SetOperation(c81100007.drop)
	c:RegisterEffect(e4)
end
function c81100007.hspfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x822) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c81100007.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81100007.hspfilter,c:GetControler(),LOCATION_SZONE,0,1,nil)
end
function c81100007.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x822) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c81100007.condition1(e,c)
	local g=Duel.GetMatchingGroup(c81100007.spfilter,tp,LOCATION_SZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>1
end
function c81100007.condition2(e,c)
	local g=Duel.GetMatchingGroup(c81100007.spfilter,tp,LOCATION_SZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>2
end
function c81100007.condition3(e,c)
	local g=Duel.GetMatchingGroup(c81100007.spfilter,tp,LOCATION_SZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>3
end
function c81100007.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c81100007.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end