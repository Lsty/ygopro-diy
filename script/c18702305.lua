--神操鸟 圣辉光之天鹤
function c18702305.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_WINDBEAST),1)
	c:EnableReviveLimit()
	--disable and destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	e1:SetCondition(c18702305.condition)
	e1:SetOperation(c18702305.disop)
	c:RegisterEffect(e1)
	--disable spsummon
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetRange(LOCATION_MZONE)
	--e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	--e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e1:SetTargetRange(1,1)
	--e1:SetTarget(c18702305.sumlimit)
	--c:RegisterEffect(e1)
	--IGNITION
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(31437713,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,187023010)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c18702305.target)
	e4:SetOperation(c18702305.operation)
	c:RegisterEffect(e4)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c18702305.efilter)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c18702305.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE or Duel.GetCurrentPhase()==PHASE_DAMAGE or Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
end
function c18702305.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	Duel.NegateEffect(ev)
	if rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function c18702305.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsType(TYPE_XYZ)
end
function c18702305.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18702305.filter,tp,LOCATION_GRAVE,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
end
function c18702305.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c18702305.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c18702305.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,257,tp,tp,false,false,POS_FACEUP)
	end
end
function c18702305.filter(c)
	return c:IsSetCard(0x257) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c18702305.filter2(c,e,tp)
	return c:IsSetCard(0x257) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18702305.efilter(e,c)
	return c:IsSetCard(0x257) and c:GetAttack()>2000
end