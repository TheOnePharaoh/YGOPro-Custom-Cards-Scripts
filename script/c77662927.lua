--No. C41 Awakened Manipulator of Terror
function c77662927.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),6,4)
	c:EnableReviveLimit()
	--add setcode
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetValue(0x1048)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetTarget(c77662927.sumlimit)
	e2:SetCondition(c77662927.dscon)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77662927,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e3:SetCondition(c77662927.thcon)
	e3:SetCost(c77662927.thcost)
	e3:SetTarget(c77662927.thtg)
	e3:SetOperation(c77662927.thop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c77662927.reptg)
	c:RegisterEffect(e4)
	--cannot target
	local e5=Effect.CreateEffect(c)
	e5:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetTargetRange(0,0xff)
	e5:SetCondition(c77662927.thcon)
	e5:SetValue(c77662927.tglimit)
	c:RegisterEffect(e5)
	--take control
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_CONTROL)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,77662927)
	e6:SetCondition(c77662927.ctcon)
	e6:SetCost(c77662927.ctcost)
	e6:SetTarget(c77662927.cttg)
	e6:SetOperation(c77662927.ctop)
	c:RegisterEffect(e6)
end
c77662927.xyz_number=41
function c77662927.dscon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c77662927.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsRankBelow(4)
end
function c77662927.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,77662926)
end
function c77662927.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77662927.thfilter(c)
	return c:IsSetCard(0x0dac406) and c:IsAbleToHand()
end
function c77662927.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77662927.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77662927.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77662927.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c77662927.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(77662927,1)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
function c77662927.tglimit(e,re,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x0dac404) and c~=e:GetHandler()
end
function c77662927.ctfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c77662927.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77662927.ctfilter,1,nil,1-tp)
end
function c77662927.controltakefilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and not c:IsCode(77662927)
end
function c77662927.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c77662927.controltakefilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c77662927.controltakefilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c77662927.controltookfilter(c,tp)
	return c:GetSummonPlayer()==1-tp and c:IsControlerCanBeChanged()
end
function c77662927.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c77662927.controltookfilter,nil,tp)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount()-1 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c77662927.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end
	local tc=g:GetFirst()
	while tc do
		if Duel.GetControl(tc,tp) then
		elseif not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
		tc=g:GetNext()
	end
end
