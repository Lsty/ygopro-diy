--灯符「萤光现象」
function c27182865.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c27182865.target)
	e1:SetOperation(c27182865.activate)
	c:RegisterEffect(e1)
end
function c27182865.filter(c)
	return c:GetCounter(0xf)>=3 and c:IsDestructable()
end
function c27182865.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c27182865.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingTarget(c27182865.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c27182865.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c27182865.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local ct=math.floor(tc:GetCounter(0xf)/3)
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and ct~=0 then
			Duel.Draw(tp,ct,REASON_EFFECT)
		end
	end
end