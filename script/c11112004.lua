--怪物猎人 青熊兽
function c11112004.initial_effect(c)
	--change position & atk down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11112004,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,11112004)
	e1:SetTarget(c11112004.target)
	e1:SetOperation(c11112004.operation)
	c:RegisterEffect(e1)
	--change position 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11112004,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,11112004)
	e2:SetCondition(c11112004.poscon)
	e2:SetTarget(c11112004.postg)
	e2:SetOperation(c11112004.posop)
	c:RegisterEffect(e2)
end
function c11112004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsPosition(POS_FACEUP_ATTACK) end
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 
	    and Duel.IsExistingTarget(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUPATTACK)
	Duel.SelectTarget(tp,Card.IsPosition,tp,0,LOCATION_MZONE,1,1,nil,POS_FACEUP_ATTACK)
end
function c11112004.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x15b) and c:IsType(TYPE_MONSTER)
end
function c11112004.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c11112004.cfilter,nil)
	if ct==0 then
	    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		    local e1=Effect.CreateEffect(e:GetHandler())
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetCode(EFFECT_UPDATE_ATTACK)
		    e1:SetValue(-500)
		    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		    tc:RegisterEffect(e1)
		end	
	else
	    if tc:IsRelateToEffect(e) and tc:IsPosition(POS_FACEUP_ATTACK) then
		    Duel.ChangePosition(tc,POS_FACEUP_DEFENCE)
	    end
	end	
end
function c11112004.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end	
function c11112004.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c11112004.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENCE,POS_FACEDOWN_DEFENCE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end