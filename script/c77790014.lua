--Zeth the Soul, 1st Arian Guardian
function c77790014.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c77790014.ttcon)
	e1:SetOperation(c77790014.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c77790014.setcon)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(c77790014.sumsuc)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(c77790014.valcheck)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetOperation(c77790014.atkop)
	c:RegisterEffect(e6)
	--direct attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e7)
	--control
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_CONTROL)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCode(EVENT_TO_GRAVE)
	e8:SetTarget(c77790014.cttg)
	e8:SetOperation(c77790014.ctop)
	c:RegisterEffect(e8)
	--equip
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(77790014,0))
	e9:SetCategory(CATEGORY_EQUIP)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e9:SetRange(LOCATION_GRAVE)
	e9:SetCondition(c77790014.cfcon)
	e9:SetTarget(c77790014.eqtg)
	e9:SetOperation(c77790014.eqop)
	c:RegisterEffect(e9)
	--eqlimit
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_EQUIP_LIMIT)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	--immune
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_EQUIP)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetCondition(c77790014.uncon)
	e11:SetValue(1)
	c:RegisterEffect(e11)
end
function c77790014.ttcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-5 and Duel.GetTributeCount(c)>=5
end
function c77790014.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,5,5)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c77790014.setcon(e,c)
	if not c then return true end
	return false
end
function c77790014.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c77790014.valcheck(e,c)
	local g=c:GetMaterial()
	c77790014.atk=g:GetSum(Card.GetAttack)
	c77790014.def=g:GetSum(Card.GetDefense)
end
function c77790014.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetMaterialCount()==0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c77790014.atk)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(c77790014.def)
	c:RegisterEffect(e2)
end
function c77790014.filter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c77790014.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c77790014.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77790014.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c77790014.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c77790014.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not Duel.GetControl(tc,tp,0,1) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c77790014.uncon(e)
	return e:GetHandler():IsStatus(STATUS_UNION)
end
function c77790014.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c77790014.filter2(c)
	return c:IsFaceup()
end
function c77790014.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77790014.filter2(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(77790014)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c77790014.filter2,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c77790014.filter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(77790014,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c77790014.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c77790014.filter2(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	c:SetStatus(STATUS_UNION,true)
end
