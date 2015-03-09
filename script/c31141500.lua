--EX米斯蒂娅
function c31141500.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3)
	c:EnableReviveLimit()
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c31141500.atkval)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c31141500.cost)
	e2:SetTarget(c31141500.target)
	e2:SetOperation(c31141500.operation)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(31141500,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCondition(c31141500.thcon)
	e4:SetTarget(c31141500.thtg)
	e4:SetOperation(c31141500.thop)
	c:RegisterEffect(e4)
end
function c31141500.atkval(e,c)
	return c:GetOverlayCount()*200
end
function c31141500.cost(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local tc=c:GetOverlayCount()
	e:SetLabel(tc)
	e:GetHandler():RemoveOverlayCard(tp,tc,tc,REASON_COST)
end
function c31141500.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
end
function c31141500.filter1(c)
	return c:IsSetCard(0x3d3)
end
function c31141500.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local rg=g:Filter(c31141500.filter1,nil)
	while rg:GetCount()>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=rg:Select(tp,1,1,nil):GetFirst()
		if tc and tc:IsAbleToGrave() then
			rg:RemoveCard(tc)
			g:RemoveCard(tc)
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
	Duel.Overlay(c,g)
end
function c31141500.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN)
end
function c31141500.filter(c)
	return c:IsSetCard(0x3d3) and c:IsType(TYPE_MONSTER) and not c:IsCode(31141500) and c:IsAbleToHand()
end
function c31141500.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c31141500.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c31141500.filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c31141500.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c31141500.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,nil,3,REASON_EFFECT)
	end
end