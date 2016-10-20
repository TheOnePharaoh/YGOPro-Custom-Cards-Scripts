--S.A.P.A Kama
function c20912300.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20912300,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetTarget(c20912300.eqtg)
	e1:SetOperation(c20912300.eqop)
	c:RegisterEffect(e1)
	--Convert race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c20912300.equipcon)
	e2:SetValue(RACE_WARRIOR)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20912300,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,20912300)
	e3:SetCost(c20912300.dacost)
	e3:SetTarget(c20912300.datg)
	e3:SetOperation(c20912300.daop)
	c:RegisterEffect(e3)
	--add setcode
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd0a3))
	e4:SetCode(EFFECT_ADD_SETCODE)
	e4:SetValue(0xd0a2)
	c:RegisterEffect(e4)
end
function c20912300.propfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and c:IsType(TYPE_MONSTER)
end
function c20912300.equipcon(e)
	return Duel.IsExistingMatchingCard(c20912300.propfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c20912300.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and c:IsRace(RACE_WARRIOR) and c:GetUnionCount()==0
end
function c20912300.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20912300.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c20912300.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c20912300.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c20912300.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	--unequip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20912300,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c20912300.uncon)
	e1:SetTarget(c20912300.sptg)
	e1:SetOperation(c20912300.spop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
	--Atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(300)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e4)
	--destroy sub
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e5:SetCondition(c20912300.uncon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--Equip limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EQUIP_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(c20912300.eqlimit)
	c:RegisterEffect(e6)
end
function c20912300.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR)
end
function c20912300.uncon(e)
	return e:GetHandler():IsStatus(STATUS_UNION)
end
function c20912300.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(20912300)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(20912300,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c20912300.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c20912300.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	local tc=e:GetHandler():GetEquipTarget()
	Duel.SetTargetCard(tc)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c20912300.daofilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd0a3) or c:IsSetCard(0xd0a2) and not c:IsCode(20912300) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20912300.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20912300.daofilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c20912300.daop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20912300.daofilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end