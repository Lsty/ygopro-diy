--空条⑨太郎
function c116810875.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3e6),aux.NonTuner(Card.IsSetCard,0x3e6),2)
	c:EnableReviveLimit()
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetTarget(c116810875.sptg)
	e1:SetOperation(c116810875.spop)
	c:RegisterEffect(e1)
	--multiattack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(c116810875.val)
	c:RegisterEffect(e2)
	--reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c116810875.rdcon)
	e3:SetOperation(c116810875.rdop)
	c:RegisterEffect(e3)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(116810875,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,116810875)
	e5:SetCost(c116810875.spcost2)
	e5:SetTarget(c116810875.sptg2)
	e5:SetOperation(c116810875.spop2)
	c:RegisterEffect(e5)
end
function c116810875.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c116810875.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,116810874,0x3e6,0x4011,1800,1800,3,RACE_AQUA,ATTRIBUTE_WATER) then
		local token=Duel.CreateToken(tp,116810874)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c116810875.afilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
function c116810875.val(e,c)
	return Duel.GetMatchingGroupCount(c116810875.afilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil)
end
function c116810875.cfilter(c)
	return c:IsSetCard(0x3e6) and c:IsType(TYPE_MONSTER) and not c:IsCode(116810875)
end
function c116810875.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c116810875.cfilter,3,e:GetHandler()) end
	local sg=Duel.SelectReleaseGroup(tp,c116810875.cfilter,3,3,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function c116810875.spfilter(c,e,tp)
	return c:IsSetCard(0x3e6) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c116810875.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c116810875.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c116810875.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c116810875.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c116810875.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c116810875.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end