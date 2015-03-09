--镜现诗·司掌宇宙的全能道士
function c19300075.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c19300075.indcon)
	e1:SetValue(c19300075.efilter)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c19300075.cost)
	e2:SetTarget(c19300075.target)
	e2:SetOperation(c19300075.operation)
	c:RegisterEffect(e2)
end
function c19300075.indcon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c19300075.efilter(e,te)
	return te:IsActiveType(TYPE_EFFECT)
end
function c19300075.cffilter(c)
	return c:IsSetCard(0x193) and not c:IsPublic()
end
function c19300075.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19300075.cffilter,tp,LOCATION_HAND,0,2,nil) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c19300075.cffilter,tp,LOCATION_HAND,0,2,2,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c19300075.filter(c)
	return (c:IsLocation(LOCATION_HAND) and not c:IsPublic()) or (c:IsLocation(LOCATION_ONFIELD) and c:IsFacedown() and not c:IsPublic())
end
function c19300075.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c19300075.filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19300075,2))
	local ac=Duel.SelectOption(tp,aux.Stringid(19300075,0),aux.Stringid(19300075,1),aux.Stringid(19300075,3))
	local ty=TYPE_SPELL
	if ac==0 then ty=TYPE_MONSTER end
	if ac==2 then ty=TYPE_TRAP end
	e:SetLabel(ty)
end
function c19300075.operation(e,tp,eg,ep,ev,re,r,rp)
	local ty=e:GetLabel()
	local g=Duel.GetMatchingGroup(c19300075.filter,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local dg=g:Filter(Card.IsType,nil,ty)
		if dg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local cg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(cg)
			if Duel.Destroy(cg,REASON_EFFECT)~=0 then
				Duel.Draw(1-tp,1,REASON_EFFECT)
			end
		end
		Duel.ShuffleHand(1-tp)
	end
end