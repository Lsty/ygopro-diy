--弹幕天邪鬼 鬼人正邪
function c13500007.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c13500007.condition1)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c13500007.splimit)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c13500007.decost)
	e3:SetTarget(c13500007.detg)
	e3:SetOperation(c13500007.deop)
	c:RegisterEffect(e3)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c13500007.destg)
	e3:SetOperation(c13500007.desop)
	c:RegisterEffect(e3)
end
function c13500007.cfilter1(c)
	return c:GetType()==TYPE_SPELL
end
function c13500007.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c13500007.cfilter1,tp,LOCATION_GRAVE,0,1,nil)
end
function c13500007.splimit(e,c,tp,sumtp,sumpos)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	if tc and not tc:IsSetCard(0x135) then
		return true
	else
		return c:IsAttribute(0xff-ATTRIBUTE_DARK)
	end
end
function c13500007.costfilter(c)
	return c:IsSetCard(0x135) and c:IsReleasable()
end
function c13500007.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13500007.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	local rt=Duel.GetMatchingGroupCount(c13500007.defilter,tp,LOCATION_EXTRA,0,nil)
	if rt>2 then rt=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local cg=Duel.SelectMatchingCard(tp,c13500007.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,rt,nil)
	Duel.Release(cg,REASON_COST)
	e:SetLabel(cg:GetCount())
end
function c13500007.defilter(c)
	return c:IsSetCard(0x135) and c:GetCode()~=13500007 and c:IsAbleToHand()
end
function c13500007.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13500007.defilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c13500007.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c13500007.defilter,tp,LOCATION_EXTRA,0,1,ct,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c13500007.desfilter(c)
	return c:IsSetCard(0x135) and c:IsAbleToDeck()
end
function c13500007.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c13500007.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c13500007.desfilter,tp,LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c13500007.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,c13500007.desfilter,tp,LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,2,2,nil)
	if tg:GetCount()==2 then
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end