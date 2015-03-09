--天界的小小姐 比那名居天子
function c6668604.initial_effect(c)
	--ntr
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,6668604)
	e1:SetTarget(c6668604.target)
	e1:SetOperation(c6668604.operation)
	c:RegisterEffect(e1)
   --ind
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_SINGLE)
	e99:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e99:SetRange(LOCATION_MZONE)
	e99:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e99:SetCondition(c6668604.indcon)
	e99:SetValue(1)
	c:RegisterEffect(e99)
end
function c6668604.indcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end	
function c6668604.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x740) and c:GetCode()~=6668604 and c:IsAbleToChangeControler()
end
function c6668604.filter2(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c6668604.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c6668604.filter2,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c6668604.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectTarget(tp,c6668604.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectTarget(tp,c6668604.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,2,0,0)
end
function c6668604.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and tc2:IsFaceup() and tc2:IsRelateToEffect(e) then
		if Duel.SwapControl(tc1,tc2) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc1:RegisterEffect(e1)
			local e2=e1:Clone()
			tc2:RegisterEffect(e2)
		end
	end
end