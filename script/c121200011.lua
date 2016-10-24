--Ynershia Torrent
--  By Shad3

local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()
local sc_id=0x73d

function scard.initial_effect(c)
	c:EnableCounterPermit(sc_id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOKEN)
	e1:SetOperation(scard.a_op)
	c:RegisterEffect(e1)
	--ATK decrease
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(scard.b_cd)
	e2:SetValue(scard.b_val)
	c:RegisterEffect(e2)
	--Inc ATK
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetDescription(aux.Stringid(s_id,3))
	e3:SetCost(scard.c_cs)
	e3:SetTarget(scard.c_tg)
	e3:SetOperation(scard.c_op)
	c:RegisterEffect(e3)
	--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CUSTOM+s_id)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetDescription(aux.Stringid(s_id,4))
	e4:SetOperation(scard.d_op)
	c:RegisterEffect(e4)
	if not scard.ytorrent then scard.ytorrent={} end
	scard.ytorrent[c]=e4
	--Global "pick negate"
	if not scard.gl_reg then
		scard.gl_reg=true
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_CHAIN_SOLVING)
		ge0:SetDescription(aux.Stringid(s_id,4))
		ge0:SetCondition(scard.gl_a_cd)
		ge0:SetOperation(scard.gl_a_op)
		Duel.RegisterEffect(ge0,0)
		local ge1=ge0:Clone()
		Duel.RegisterEffect(ge1,1)
	end
end

function scard.a_fil(c,at)
	return c:GetAttack()<=at
end

function scard.a_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(s_id,0))
	local n=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10)
	c:AddCounter(sc_id,n)
	n=c:GetCounter(sc_id)*1000
	if n==0 then return end
	c:RegisterFlagEffect(s_id,RESET_CHAIN,0,0)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):Filter(scard.a_fil,nil,n)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(s_id,1)) then
		Duel.BreakEffect()
		local tg=Group.CreateGroup()
		repeat
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			tg:AddCard(tc)
			n=n-tc:GetAttack()
			g=g:Filter(scard.a_fil,tc,n)
		until g:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(s_id,2))
		Duel.HintSelection(tg)
		Duel.Destroy(tg,REASON_EFFECT)
	end
end

function scard.b_cd(e)
	return e:GetHandler():GetFlagEffect(s_id)==1
end

function scard.b_val(e,c)
	return -200*e:GetHandler():GetCounter(sc_id)
end

function scard.c_cs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,sc_id,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,sc_id,1,REASON_COST)
end

function scard.c_fil(c)
	return c:IsSetCard(sc_id) and c:IsFaceup()
end

function scard.c_tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and scard.c_fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(scard.c_fil,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,scard.c_fil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,tp,400)
end

function scard.c_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(400)
		tc:RegisterEffect(e1)
	end
end

function scard.d_fil(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(sc_id) and c:IsFaceup()
end

function scard.d_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	Duel.BreakEffect()
	e:GetHandler():AddCounter(sc_id,2)
end

function scard.gl_a_fil(c)
	return c.ytorrent and c.ytorrent[c] and c:IsFaceup() and not c:IsDisabled()
end

function scard.gl_a_cd(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,s_id)==0 and Duel.IsExistingMatchingCard(scard.gl_a_fil,tp,LOCATION_SZONE,0,1,nil) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		return g and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and g:IsExists(scard.d_fil,1,nil,tp) and Duel.IsChainDisablable(ev)
	end
	return false
end

function scard.gl_a_op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(s_id,4)) then
		Duel.RegisterFlagEffect(tp,s_id,RESET_PHASE+PHASE_END,0,1)
		local g=Duel.GetMatchingGroup(scard.gl_a_fil,tp,LOCATION_SZONE,0,nil)
		if g:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
			g=g:Select(tp,1,1,nil)
		end
		Duel.HintSelection(g)
		Duel.RaiseSingleEvent(g:GetFirst(),EVENT_CUSTOM+s_id,re,r,rp,ep,ev)
	end
end
