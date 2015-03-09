--VOCALOID-苍姬ラピス
function c79900021.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,3)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79900021,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c79900021.con1)
	e1:SetCost(c79900021.cost)
	e1:SetTarget(c79900021.tg1)
	e1:SetOperation(c79900021.op1)
	c:RegisterEffect(e1)
	--handes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79900021,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79900021.con2)
	e2:SetCost(c79900021.cost)
	e2:SetTarget(c79900021.tg2)
	e2:SetOperation(c79900021.op2)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79900021,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79900021.con3)
	e3:SetCost(c79900021.cost)
	e3:SetTarget(c79900021.tg3)
	e3:SetOperation(c79900021.op3)
	c:RegisterEffect(e3)
end
function c79900021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79900021.con1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)>2000 then
		return e:GetHandler():GetFlagEffect(79900021)==0 and e:GetHandler():GetFlagEffect(79900022)==0
	else
		return e:GetHandler():GetFlagEffect(79900021)<=1 and e:GetHandler():GetFlagEffect(79900022)==0
	end
end
function c79900021.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	e:GetHandler():RegisterFlagEffect(79900021,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RegisterFlagEffect(79900022,RESET_EVENT+0x1fe0000,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c79900021.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c79900021.con2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)>2000 then
		return e:GetHandler():GetFlagEffect(79900021)==0 and e:GetHandler():GetFlagEffect(79900023)==0
	else
		return e:GetHandler():GetFlagEffect(79900021)<=1 and e:GetHandler():GetFlagEffect(79900023)==0
	end
end
function c79900021.filter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c79900021.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c79900021.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79900021.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c79900021.filter,tp,0,LOCATION_MZONE,1,1,nil)
	e:GetHandler():RegisterFlagEffect(79900021,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RegisterFlagEffect(79900023,RESET_EVENT+0x1fe0000,0,1)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c79900021.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not Duel.GetControl(tc,tp,PHASE_END,1) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c79900021.con3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)>2000 then
		return e:GetHandler():GetFlagEffect(79900021)==0 and e:GetHandler():GetFlagEffect(79900024)==0
	else
		return e:GetHandler():GetFlagEffect(79900021)<=1 and e:GetHandler():GetFlagEffect(79900024)==0
	end
end
function c79900021.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	e:GetHandler():RegisterFlagEffect(79900021,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RegisterFlagEffect(79900024,RESET_EVENT+0x1fe0000,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c79900021.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end