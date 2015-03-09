--Gosick·灰狼
function c12250011.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x4c9),4,2)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(EVENT_TO_DECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c12250011.thcon)
	e1:SetTarget(c12250011.thtg)
	e1:SetOperation(c12250011.thop)
	c:RegisterEffect(e1)
	--destroy & damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_MSET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c12250011.con)
	e5:SetCost(c12250011.setcost)
	e5:SetTarget(c12250011.settg)
	e5:SetOperation(c12250011.setop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SSET)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function c12250011.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c12250011.thfilter(c)
	return c:IsAbleToDeck() and c:IsFacedown()
end
function c12250011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c12250011.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c12250011.tfilter(c,e,tp)
	return (c:IsSSetable() and (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsSetCard(0x598) or c:IsCode(9791914) or c:IsCode(58132856))) or (c:IsMSetable(true,nil) and c:IsType(TYPE_MONSTER))
end
function c12250011.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsChainDisablable(0) and not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_CANNOT_MSET) and not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_CANNOT_SSET) then
		if Duel.GetMatchingGroupCount(c12250011.tfilter,1-tp,LOCATION_HAND,0,nil,e,1-tp)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(12250003,0)) then
			local sc=Group.GetFirst(Duel.SelectMatchingCard(1-tp,c12250011.tfilter,1-tp,LOCATION_HAND,0,1,1,nil,e,1-tp))
			if sc:IsType(TYPE_SPELL+TYPE_TRAP) then
				Duel.SSet(1-tp,sc)
			elseif (sc:IsSetCard(0x598) or sc:IsCode(9791914) or sc:IsCode(58132856)) and Duel.SelectYesNo(1-tp,aux.Stringid(12250003,1)) then
				Duel.SSet(1-tp,sc)
			else
				Duel.MSet(1-tp,sc,true,nil)
			end
			return
		end
	end
	local g=Duel.GetMatchingGroup(c12250011.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c12250011.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c12250011.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(12250011)==0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RegisterFlagEffect(12250011,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12250011.filter(c)
	return c:IsAbleToHand() and c:IsFacedown()
end
function c12250011.setfilter(c,e)
	return c:IsFacedown() and c:IsLocation(LOCATION_ONFIELD)
end
function c12250011.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c12250011.setfilter,1,nil,nil) and Duel.IsExistingMatchingCard(c12250011.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetTargetCard(eg)
end
function c12250011.setop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c12250011.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then return end
	if not eg:IsExists(c12250011.setfilter,1,nil,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	local tc=eg:GetFirst()
	local mg=Group.CreateGroup()
	local m=0
	while tc do
		if tc:IsLocation(LOCATION_ONFIELD) and tc:IsRelateToEffect(e) and tc:IsFacedown() then
			mg:AddCard(tc)
			if (res==0 and tc:IsType(TYPE_MONSTER)) or (res==1 and tc:IsType(TYPE_SPELL)) or (res==2 and tc:IsType(TYPE_TRAP)) then m=m+1 end
		end
		tc=eg:GetNext()
	end
	Duel.ConfirmCards(tp,mg)
	if m~=0 then
		local g=Duel.GetMatchingGroup(c12250011.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end