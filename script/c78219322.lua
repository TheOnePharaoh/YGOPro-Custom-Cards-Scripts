--The City of Nano Engineering
function c78219322.initial_effect(c)
	c:SetCounterLimit(0x1115,7)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_XYZ))
	e2:SetValue(c78219322.atkval)
	e2:SetCondition(c78219322.atkcon)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78219322,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_DRAW)
	e3:SetOperation(c78219322.ctop)
	c:RegisterEffect(e3)
	--destroy & draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(78219322,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c78219322.destg)
	e4:SetOperation(c78219322.desop)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetTarget(c78219322.desreptg)
	c:RegisterEffect(e5)
	--rank-up
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(78219322,2))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_BE_BATTLE_TARGET)
	e6:SetCondition(c78219322.spcon)
	e6:SetCost(c78219322.spcost)
	e6:SetTarget(c78219322.sptg)
	e6:SetOperation(c78219322.spop)
	c:RegisterEffect(e6)
	if not c78219322.global_check then
		c78219322.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DAMAGE)
		ge1:SetOperation(c78219322.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c78219322.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,78219322,RESET_PHASE+PHASE_END,0,1)
end
function c78219322.atkcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c78219322.atkval(e,c)
	return e:GetHandler():GetCounter(0x1115)*100
end
function c78219322.ctop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return end
	e:GetHandler():AddCounter(0x1115,1)
end
function c78219322.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7ad30) and c:IsDestructable()
end
function c78219322.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c78219322.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78219322.desfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c78219322.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	
end
function c78219322.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local p=tc:GetControler()
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c78219322.repfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7ad30) and c:IsAbleToRemoveAsCost()
end
function c78219322.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c78219322.repfilter,tp,LOCATION_SZONE,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(78219322,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c78219322.repfilter,tp,LOCATION_SZONE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		return true
	else return false end
end
function c78219322.spcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsFaceup() and at:IsControler(tp) and at:IsSetCard(0x48) and not at:IsSetCard(0x1048)
end
function c78219322.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():GetCounter(0x1115)>=7 end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c78219322.filter(c,e,tp,mc,no)
	return c.xyz_number==no and c:IsSetCard(0x1048) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c78219322.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local at=Duel.GetAttackTarget()
		local m=_G["c"..at:GetCode()]
		return m and m.xyz_number and Duel.IsExistingMatchingCard(c78219322.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,at,m.xyz_number)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c78219322.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateAttack() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetAttackTarget()
	local m=_G["c"..tc:GetCode()]
	if tc:IsFacedown() or not tc:IsRelateToBattle() or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or not m then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c78219322.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,m.xyz_number)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
