--虚无的陨星
function c9991020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(9991020)
	e1:SetCountLimit(1,9991020+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9991020.target)
	e1:SetOperation(c9991020.activate)
	c:RegisterEffect(e1)
	if not c9991020.global_check then
		c9991020.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(c9991020.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9991020.filter(c)
	return c:IsSetCard(0xeff) and c:IsAbleToHand() and (c:IsLocation(LOCATION_GRAVE) or c:IsType(TYPE_PENDULUM))
end
function c9991020.actfil(c,tp)
	return c:IsSetCard(0xeff) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp
end
function c9991020.regop(e,tp,eg,ep,ev,re,r,rp)
	local sf=0
	if eg:IsExists(c9991020.actfil,1,nil,0) then sf=sf+1 end
	if eg:IsExists(c9991020.actfil,1,nil,1) then sf=sf+2 end
	Duel.RaiseEvent(eg,9991020,e,r,rp,ep,sf)
end
function c9991020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9991020.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) and bit.band(bit.rshift(ev,tp),1)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c9991020.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9991020.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT) Duel.ConfirmCards(1-tp,g)
	Duel.BreakEffect() Duel.Draw(tp,1,REASON_EFFECT)
	if e:GetHandler():IsRelateToEffect(e) then Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT) end
end
