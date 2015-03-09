--VOCALOID-Lily
function c79900011.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c79900011.cost)
	e1:SetTarget(c79900011.sptg)
	e1:SetOperation(c79900011.spop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c79900011.indcon)
	e2:SetOperation(c79900011.activate)
	c:RegisterEffect(e2)
end
function c79900011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79900011.spfilter(c,e,tp)
	return c:IsSetCard(0x799) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79900011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79900011.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c79900011.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79900011.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENCE)~=0 then
		if Duel.GetLP(tp)>2000 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
			Duel.BreakEffect()
			e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		end
	end
end
function c79900011.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)~=2000
end
function c79900011.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,2000)
end