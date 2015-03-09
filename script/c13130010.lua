--秘神流雏 键山雏
function c13130010.initial_effect(c)
	c:SetUniqueOnField(1,0,13130010)
	--summon or set without tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13130010,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c13130010.ntcon)
	c:RegisterEffect(e1)
	--SSet
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetCondition(c13130010.setcon)
	e2:SetTarget(c13130010.settg)
	e2:SetOperation(c13130010.setop)
	c:RegisterEffect(e2)
	--disable and destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAIN_ACTIVATING)
	e3:SetOperation(c13130010.disop)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c13130010.indcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c13130010.indcon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--tohand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(13130010,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1)
	e6:SetCondition(c13130010.thcon)
	e6:SetTarget(c13130010.thtg)
	e6:SetOperation(c13130010.thop)
	c:RegisterEffect(e6)
	--draw
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(13130010,2))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1)
	e6:SetCondition(c13130010.drcon)
	e6:SetCost(c13130010.drcost)
	e6:SetTarget(c13130010.drtg)
	e6:SetOperation(c13130010.drop)
	c:RegisterEffect(e6)
end
function c13130010.ntcon(e,c)
	if c==nil then return true end
	return c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
end
function c13130010.filter(c)
	return c:IsType(TYPE_TRAP) and c:IsFaceup()
end
function c13130010.setcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler()==nil then return true end
	return Duel.GetMatchingGroupCount(c13130010.filter,tp,LOCATION_ONFIELD,0,nil)==1
end
function c13130010.setfilter(c,e,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c13130010.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c13130010.setfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g2=Duel.SelectTarget(tp,c13130010.setfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g2,1,0,0)
end
function c13130010.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
	end
end
function c13130010.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or Duel.GetMatchingGroupCount(c13130010.filter,tp,LOCATION_ONFIELD,0,nil)~=2 then return end
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if g and g:IsContains(e:GetHandler()) then
			Duel.NegateEffect(ev)
			if re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(re:GetHandler(),REASON_EFFECT)
			end
		end
	end
end
function c13130010.indcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetMatchingGroupCount(c13130010.filter,tp,LOCATION_ONFIELD,0,nil)==3
end
function c13130010.thcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(c13130010.filter,tp,LOCATION_ONFIELD,0,nil)~=4 then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c13130010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c13130010.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c13130010.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c13130010.filter,tp,LOCATION_ONFIELD,0,nil)==5
end
function c13130010.costfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c13130010.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13130010.costfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c13130010.costfilter,tp,LOCATION_ONFIELD,0,1,ct,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c13130010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c13130010.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end