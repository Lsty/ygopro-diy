--各方会战 比那名居天子
function c6668607.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x740),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_EARTH),1)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,6668607)
	e1:SetCondition(c6668607.discon)
	e1:SetTarget(c6668607.distg)
	e1:SetOperation(c6668607.disop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,6658607)
	e2:SetCondition(c6668607.spcon)
	e2:SetTarget(c6668607.sptg)
	e2:SetOperation(c6668607.spop)
	c:RegisterEffect(e2)
	--ind
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_SINGLE)
	e99:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e99:SetRange(LOCATION_MZONE)
	e99:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e99:SetCondition(c6668607.indcon)
	e99:SetValue(1)
	c:RegisterEffect(e99)
end
function c6668607.indcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end	
function c6668607.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c6668607.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c6668607.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6668607.filter1,tp,0,LOCATION_MZONE,1,nil) end
end
function c6668607.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c6668607.filter1,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	if not tc then return end
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(600)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c6668607.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x740) and c:IsControler(tp)
end
function c6668607.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c6668607.cfilter,1,nil,tp)
end
function c6668607.spfilter(c,e,tp)
	return c:IsSetCard(0x740) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6668607.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c6668607.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c6668607.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c6668607.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c6668607.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end