--夜夜  吹鸣绝冲:楸木太刀影
function c1314525.initial_effect(c)
    c:EnableReviveLimit()
    --to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1314525,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(0x2)
	e1:SetCost(c1314525.tocost)
	e1:SetTarget(c1314525.totg)
	e1:SetOperation(c1314525.toop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1314525,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(0x4)
	e2:SetCondition(c1314525.descon)
	e2:SetTarget(c1314525.destg)
	e2:SetOperation(c1314525.desop)
	c:RegisterEffect(e2)
end
function c1314525.cffilter(c)
	return c:IsSetCard(0x9fd) or c:IsSetCard(0x9ff) and c:IsAbleToGraveAsCost()
end
function c1314525.tocost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and 
		Duel.IsExistingMatchingCard(c1314525.costfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1314525.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end	
function c1314525.tfilter(c)
	return c:IsType(0x1) and c:IsAbleToDeck()
end
function c1314525.totg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and c1314525.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1314525.tfilter,tp,0,0x4,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c1314525.tfilter,tp,0,0x4,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c1314525.toop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,0x40)
	end
end
function c1314525.descon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker() 
	if not ac:IsSetCard(0x9fd) or ac:IsControler(1-tp) then return false end
	local bc=ac:GetBattleTarget()
	return bc and bit.band(bc:GetSummonType(),0x40000000)==0x40000000 and bc:IsPreviousLocation(0x40)
end
function c1314525.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttacker():GetBattleTarget():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttacker():GetBattleTarget(),1,0,0)
end
function c1314525.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttacker():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,0x40)
	end
end
