--Toon Destiny HERO - Plasma
--Created By ALANMAC95, Scripted By TheOnePharaoh
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

function scard.initial_effect(c)
	if not scard.reg then
	scard.reg=true
	end
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(scard.dircon)
	c:RegisterEffect(e4)

	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(s_id,1))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(scard.eqcon)
	e5:SetTarget(scard.eqtg)
	e5:SetOperation(scard.eqop)
	c:RegisterEffect(e5)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e6)
  if not scard.global_check then
		scard.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetLabel(s_id)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
	end
end
function scard.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function scard.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function scard.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function scard.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(scard.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(scard.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function scard.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3
		and Duel.CheckReleaseGroup(c:GetControler(),nil,3,nil)
end
function scard.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),nil,3,3,nil)
	Duel.Release(g,REASON_COST)
end
function scard.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=e:GetLabelObject()
	return ec==nil or ec:GetFlagEffect(s_id)==0
end
function scard.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function scard.eqlimit(e,c)
	return e:GetOwner()==c
end
function scard.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local atk=tc:GetTextAttack()/2
			if tc:IsFacedown() then atk=0 end
			if atk<0 then atk=0 end
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			tc:RegisterFlagEffect(s_id,RESET_EVENT+0x1fe0000,0,0)
			e:SetLabelObject(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(scard.eqlimit)
			tc:RegisterEffect(e1)
			if atk>0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(atk)
				tc:RegisterEffect(e2)
			end
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end