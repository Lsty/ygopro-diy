--怪物猎人 随从猫
function c11112044.initial_effect(c)
    --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11112044,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11112044)
	e1:SetCost(c11112044.cost)
	e1:SetTarget(c11112044.target)
	e1:SetOperation(c11112044.operation)
	c:RegisterEffect(e1)
	--Level change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11112044,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11112044)
	e2:SetCondition(c11112044.lvcon)
	e2:SetTarget(c11112044.lvtg)
	e2:SetOperation(c11112044.lvop)
	c:RegisterEffect(e2)
end	
function c11112044.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c11112044.filter(c,e,tp)
	return c:GetCode()==11112044 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11112044.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c11112044.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c11112044.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct==0 then return end
	local g=Duel.GetMatchingGroup(c11112044.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()>0 then
		local t1=g:GetFirst()
		local t2=g:GetNext()
		Duel.SpecialSummonStep(t1,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		if t2 and ct>1 and Duel.SelectYesNo(tp,aux.Stringid(11112044,1)) then
			Duel.SpecialSummonStep(t2,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		end
		Duel.SpecialSummonComplete()
		Duel.ShuffleDeck(tp)
		Duel.DiscardDeck(tp,1,REASON_EFFECT)
	end
end
function c11112044.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c11112044.lvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15b) and c:IsLevelAbove(1)
end
function c11112044.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11112044.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c11112044.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11112044.lvfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end