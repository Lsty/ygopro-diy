--深红的夜行性恶魔 蕾米莉亚·斯卡雷特
function c73300003.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c73300003.tg1)
	e1:SetOperation(c73300003.op1)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c73300003.descon)
	e2:SetTarget(c73300003.destg)
	e2:SetOperation(c73300003.desop)
	c:RegisterEffect(e2)
end
function c73300003.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x733) and c:IsAbleToHand()
end
function c73300003.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,73300003)==0 and Duel.IsExistingMatchingCard(c73300003.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c73300003.filter2(c)
	return c:IsType(TYPE_TRAP) or (c:GetType()==TYPE_SPELL and not c:IsSetCard(0x734))
end
function c73300003.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c73300003.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local g1=Duel.GetMatchingGroup(c73300003.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		if g1:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
	end
end
function c73300003.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_DESTROY)~=0
		and bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)~=0
		and bit.band(e:GetHandler():GetPreviousPosition(),POS_FACEDOWN)~=0
end
function c73300003.desfilter(c)
	return c:IsDestructable()
end
function c73300003.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c73300003.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c73300003.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c73300003.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c73300003.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end