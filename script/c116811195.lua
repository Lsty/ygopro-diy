--尸骸之秋
function c116811195.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c116811195.target)
	e1:SetOperation(c116811195.activate)
	c:RegisterEffect(e1)
end
function c116811195.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3e2) and c:GetSequence()<5 
end
function c116811195.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c116811195.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c116811195.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
end
function c116811195.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c116811195.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	local ct1=Duel.SendtoGrave(g,REASON_EFFECT)
	if ct1==0 then return end
	local ct2=Duel.Draw(tp,ct1,REASON_EFFECT)
end