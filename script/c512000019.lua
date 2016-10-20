--CNo.80 葬装覇王レクイエム・イン・バーサーク
function c512000019.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(876330,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c512000019.eqtg)
	e1:SetOperation(c512000019.eqop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(612115,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,512000019)
	e2:SetCost(c512000019.rmcost)
	e2:SetTarget(c512000019.rmtg)
	e2:SetOperation(c512000019.rmop)
	c:RegisterEffect(e2)
	if not c512000019.global_check then
		c512000019.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c512000019.numchk)
		Duel.RegisterEffect(ge2,0)
	end
end
c512000019.xyz_number=80
function c512000019.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c512000019.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	local sp=0
	if c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,93568288) then
		sp=1
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c512000019.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(2000)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
	if sp==1 then
		--disable
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_BE_BATTLE_TARGET)
		e3:SetRange(LOCATION_SZONE)
		e3:SetCondition(c512000019.discon)
		e3:SetOperation(c512000019.disop)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3)
		--destroy replace
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
		e4:SetCode(EFFECT_DESTROY_REPLACE)
		e4:SetTarget(c512000019.reptg)
		e4:SetOperation(c512000019.repop)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e4)
	end
end
function c512000019.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c512000019.discon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:GetControler()==tp and (ec==Duel.GetAttacker() or ec==Duel.GetAttackTarget()) and ec:GetBattleTarget()
end
function c512000019.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget():GetBattleTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2)
end
function c512000019.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
	if Duel.SelectYesNo(tp,aux.Stringid(61965407,0)) then
		e:GetHandler():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c512000019.repop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	c:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.SendtoGrave(c,REASON_EFFECT+REASON_REPLACE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67441435,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c512000019.spcost)
	e1:SetTarget(c512000019.sptg)
	e1:SetOperation(c512000019.spop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
function c512000019.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c512000019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c512000019.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
function c512000019.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c512000019.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c512000019.rmop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local op=0
	if sg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) and sg:IsExists(Card.IsType,1,nil,TYPE_SPELL+TYPE_TRAP) then
		op=Duel.SelectOption(tp,aux.Stringid(26495087,1),aux.Stringid(99458769,3))
	elseif sg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
		Duel.SelectOption(tp,aux.Stringid(26495087,1))
		op=0
	else
		Duel.SelectOption(tp,aux.Stringid(99458769,3))
		op=1
	end
	local bg
	if op==0 then
		bg=sg:Filter(Card.IsType,nil,TYPE_MONSTER)
	else
		bg=sg:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
	end
	if Duel.CheckLPCost(1-tp,bg:GetCount()*400) and Duel.SelectYesNo(1-tp,aux.Stringid(1639384,0)) then
		Duel.PayLPCost(1-tp,bg:GetCount()*400)
		if Duel.IsChainDisablable(0) then
			Duel.NegateEffect(0)
			return
		end
	end
	Duel.Remove(bg,POS_FACEUP,REASON_EFFECT)
end
function c512000019.numchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,20563387)
	Duel.CreateToken(1-tp,20563387)
end
